package io.github.dagezi.vectortest;

import android.graphics.drawable.Drawable;
import android.graphics.drawable.VectorDrawable;
import android.support.graphics.drawable.VectorDrawableCompat;
import android.support.v4.content.res.ResourcesCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.content.res.AppCompatResources;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        RecyclerView listView = (RecyclerView) findViewById(R.id.imagesList);
        listView.setAdapter(new DrawableResourcesAdaptor());
        listView.setLayoutManager(new LinearLayoutManager(this));
        DividerItemDecoration dividerItemDecoration =
                new DividerItemDecoration(this, DividerItemDecoration.VERTICAL);
        listView.addItemDecoration(dividerItemDecoration);
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        private final R.drawable drawableResources = new R.drawable();

        private TextView nameView;
        private ImageView imageView;

        public ViewHolder(View itemView) {
            super(itemView);

            nameView = (TextView) itemView.findViewById(R.id.name);
            imageView = (ImageView) itemView.findViewById(R.id.image);
        }

        public void populate(Field field) {
            nameView.setText(field.getName());

            try {
                int resourceId = field.getInt(drawableResources);
                imageView.setImageResource(resourceId);
                imageView.setVisibility(View.VISIBLE);
            } catch (Exception e) {
                imageView.setVisibility(View.GONE);
                e.printStackTrace();
            }
        }
    }

    private class DrawableResourcesAdaptor extends RecyclerView.Adapter<ViewHolder> {
        private final List<Field> fields = new ArrayList<>();

        public DrawableResourcesAdaptor() {
             R.drawable drawableResources = new R.drawable();

             for (Field f : R.drawable.class.getDeclaredFields()) {
                 try {
                     int resourceId = 0;
                     resourceId = f.getInt(drawableResources);
                     Drawable drawable = AppCompatResources.getDrawable(MainActivity.this, resourceId);
                     if (drawable instanceof VectorDrawableCompat) {
                         fields.add(f);
                     }
                 } catch (Exception e) {
                     e.printStackTrace();
                 }
             }
        }

        @Override
        public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
            View view = LayoutInflater.from(MainActivity.this)
                    .inflate(R.layout.listitem_drawables, parent, false);
            return new ViewHolder(view);
        }

        @Override
        public void onBindViewHolder(ViewHolder holder, int position) {
            holder.populate(fields.get(position));
        }

        @Override
        public int getItemCount() {
            return fields.size();
        }
    }
}
